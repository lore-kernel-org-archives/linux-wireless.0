Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbHSC6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 22:58:51 -0400
Date: Tue, 18 Aug 2015 19:58:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Rachel Kim <rachel.kim@atmel.com>, Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv3] staging: wilc1000: use netdev_* instead of printk
Message-ID: <20150819025850.GC4588@kroah.com> (sfid-20150819_045909_783778_58743517)
References: <20150817195542.GB6591@kroah.com>
 <b5c4c3dd4babd0cd4daef51626816e95c6d8ee9d.1439852779.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b5c4c3dd4babd0cd4daef51626816e95c6d8ee9d.1439852779.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 07:06:40PM -0400, Raphaël Beamonte wrote:
> Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>

You can't submit a patch with no changelog information, sorry.

Always build your patches, otherwise you make maintainers really grumpy
as it breaks their build.

greg k-h
