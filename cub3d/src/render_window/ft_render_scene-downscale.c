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

void	ft_render_downscaled_texture(t_map *map)
{
	int	divider;

	divider = TEXTURE_SIZE / (TEXTURE_SIZE - map->slc->height) + 1;
	ft_render_downscaled_first_half(map, divider);
	ft_render_downscaled_second_half(map, divider);
}

void	ft_render_downscaled_first_half(t_map *map, int divider)
{
	int	x;
	int	i;
	int	limit;

	x = 0;
	i = 0;
	limit = map->slc->height / 4;
	while (i < limit && map->y < PROJ_PLANE_HEIGHT) // Second condition TBD
		ft_render_downscaled_first_half_pixel_put(map, divider, &i, &x);
	x = (TEXTURE_SIZE / 4);
	limit = map->slc->height / 2;
	while (i < limit && map->y < PROJ_PLANE_HEIGHT) // Second condition TBD
		ft_render_downscaled_first_half_pixel_put(map, divider, &i, &x);
}

void	ft_render_downscaled_first_half_pixel_put(t_map *map, int divider,
	int *i, int *x)
{
	if (*x % divider != 0)
	{
		my_mlx_pixel_put(map->view->plane_data, map->slc->column, map->y,
			map->rdata->textures[NO_TEXTURE_INDEX].texture_columns[*x][0]);
		*i += 1;
		map->y += 1;
	}
	*x += 1;
}

void	ft_render_downscaled_second_half(t_map *map, int divider)
{
	int	i;
	int	x;
	int	limit;

	i = map->slc->height - 1;
	x = TEXTURE_SIZE - 1;
	limit = map->slc->height / 4 * 3;
	while (i > limit)
		ft_render_downscaled_second_half_pixel_put(map, divider, &i, &x);
	x = TEXTURE_SIZE - (TEXTURE_SIZE / 4);
	limit = map->slc->height / 2;
	while (i >= limit)
		ft_render_downscaled_second_half_pixel_put(map, divider, &i, &x);
}

void	ft_render_downscaled_second_half_pixel_put(t_map *map, int divider,
	int *i, int *x)
{
	if (*x % divider != 0)
	{
		my_mlx_pixel_put(map->view->plane_data, map->slc->column, map->y,
			map->rdata->textures[NO_TEXTURE_INDEX].texture_columns[*x][0]);
		*i -= 1;
		map->y += 1;
	}
	*x -= 1;
}
