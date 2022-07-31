/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_map_data_manip.c                                :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ngasco <marvin@42.fr>                      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/06/09 13:14:49 by ngasco            #+#    #+#             */
/*   Updated: 2022/07/19 12:52:06 by jsolinis         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../cub3d.h"
#include "../../Libft/libft.h"

void ft_post_validation_data_manip(t_map *map)
{
	map->rdata->c_col_int = ft_rgb_str_to_int(map->c_color);
	ft_write_debug_msg_int("Ceiling color is ", map->rdata->c_col_int);
	map->rdata->f_col_int = ft_rgb_str_to_int(map->f_color);
	ft_write_debug_msg_int("Floor color is ", map->rdata->f_col_int);
	ft_validate_texture_files(map);
	ft_parse_all_texture_files(map);
}

void	ft_parse_all_texture_files(t_map *map)
{
	map->rdata->textures = (t_tdata *)malloc(sizeof(t_tdata) * NUM_TEXTURES);
	map->rdata->textures[NO_TEXTURE_INDEX] = ft_parse_texture_file(map->no_path);
	map->rdata->textures[EA_TEXTURE_INDEX] = ft_parse_texture_file(map->ea_path);
	map->rdata->textures[SO_TEXTURE_INDEX] = ft_parse_texture_file(map->so_path);
	map->rdata->textures[WE_TEXTURE_INDEX] = ft_parse_texture_file(map->we_path);
	ft_write_debug_msg_int("All textures parsed ", 0);	
}

t_tdata ft_parse_texture_file(char *texture_path)
{
	t_tdata	texture;
	int 	fd;
	char 	*line;

	fd = open(texture_path, O_RDONLY);
	if (fd == -1)
		ft_open_file_error();
	ft_memset(&texture, 0, sizeof(t_tdata));
	line = NULL;
	ft_readline_asset_sizes(fd, line, &texture);
	ft_readline_color_codes(fd, line, &texture);
	ft_readline_char_map(fd, line, &texture);
	return (texture);
}

