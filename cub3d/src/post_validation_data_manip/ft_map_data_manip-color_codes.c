/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_scene_desc_file_validation.c                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ngasco <marvin@42.fr>                      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/06/09 13:14:49 by ngasco            #+#    #+#             */
/*   Updated: 2022/06/09 13:14:58 by ngasco           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../cub3d.h"
#include "../../Libft/libft.h"

void	ft_readline_color_codes(int fd, char *line, t_tdata *texture)
{
	line = get_next_line(fd);
	while (line)
	{
		line = get_next_line(fd);
		if (ft_str_contains_char(line, '#'))
		{
			ft_parse_char_col(line, texture);
			free(line);
			break ;
		}
		free(line);
	}
	while (line)
	{
		line = get_next_line(fd);
		if (!ft_str_contains_char(line, '#'))
		{
			free(line);
			break ;
		}
		ft_parse_char_col(line, texture);
		free(line);
	}
}

void	ft_parse_char_col(char *line, t_tdata *texture)
{
	struct s_cinfo	*curr;

	curr = texture->col_info_list;
	if (!curr)
	{
		texture->col_info_list = ft_create_col_info_struct(line);
		return ;
	}
	while (curr)
	{
		if (curr->next)
			curr = curr->next;
		else
			break ;
	}
	curr->next = ft_create_col_info_struct(line);
}

struct s_cinfo	*ft_create_col_info_struct(char *line)
{
	int				i;
	char			col_char;
	char			*col_hex;
	struct s_cinfo	*col_info;

	i = 0;
	col_char = '\0';
	col_hex = NULL;
	while (line[i] != '\0')
	{
		if (line[i] == '\"')
			col_char = line[i + 1];
		if (line[i] == '#')
		{
			col_hex = ft_substr(line, i + 1, 6);
			break ;
		}
		i++;
	}
	col_info = malloc(sizeof(struct s_cinfo));
	col_info->col_char = col_char;
	col_info->col_int = ft_hex_str_to_int(col_hex);
	col_info->next = NULL;
	return (col_info);
}

int	ft_hex_str_to_int(char *hex)
{
	int	curr_digit;
	int	num_digits;
	int	i;
	int	result;

	i = 0;
	result = 0;
	num_digits = ft_strlen(hex) - 1;
	while (hex[i] != '\0')
	{
		if (hex[i] >= 'A' && hex[i] <= 'F')
			curr_digit = hex[i] - DIFF_TO_NUM;
		else
			curr_digit = hex[i] - '0';
		result += curr_digit * (int)pow((float)16, (float)num_digits);
		num_digits--;
		i++;
	}
	return (result);
}
