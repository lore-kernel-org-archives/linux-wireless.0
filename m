Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbICBT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 21:19:27 -0400
Date: Wed, 2 Sep 2015 18:19:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/2] staging: wilc1000: remove FREE_WILC_BUFFER()
Message-ID: <20150903011926.GA30914@kroah.com> (sfid-20150903_032005_498697_71191178)
References: <20150819025942.GD4588@kroah.com>
 <cover.1439953865.git.raphael.beamonte@gmail.com>
 <98b8f344a4c610b9273a0c753a1ec470dee10153.1439953865.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <98b8f344a4c610b9273a0c753a1ec470dee10153.1439953865.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2015 at 11:14:49PM -0400, Raphaël Beamonte wrote:
> It was just a wrapper around kfree(), so call that instead.
> 
> Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_exported_buf.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Turns out this file is never even built, you should just remove it :)

