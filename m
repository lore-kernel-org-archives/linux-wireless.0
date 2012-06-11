Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42581 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2FKSac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 14:30:32 -0400
MIME-Version: 1.0
In-Reply-To: <1338115108-19091-1-git-send-email-ozancag@gmail.com>
References: <1338115108-19091-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 11 Jun 2012 11:30:12 -0700
Message-ID: <CAB=NE6WyAa7fhC-VvMr+19A80x_VNbbPOrZJCp+6tv5Q+HONxA@mail.gmail.com> (sfid-20120611_203037_562582_F2C5C069)
Subject: Re: [PATCH 1/2] bin/ckmake: Relax distribution check
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 27, 2012 at 3:38 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Do not check specifically for Ubuntu as we will be using Ubuntu vanilla
> kernels for every distribution.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

This change removes the lsb check but -- at this point in the patch
life cycle if you run this code it will not work for other Linux
distributions. Its best to leave this patch then for later *after* you
have addressed fixing using the script for other Linux distributions.

  Luis
