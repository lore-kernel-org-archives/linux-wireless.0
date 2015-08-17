Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbHQUBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 16:01:03 -0400
Date: Mon, 17 Aug 2015 13:01:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv2 4/5] staging: wilc1000: remove FREE_WILC_BUFFER()
Message-ID: <20150817200102.GA28880@kroah.com> (sfid-20150817_220125_692376_40B3D365)
References: <cover.1439838526.git.raphael.beamonte@gmail.com>
 <1ed2c34e8fde92cd4813ae549ba0a0a3fd92afd0.1439838526.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1ed2c34e8fde92cd4813ae549ba0a0a3fd92afd0.1439838526.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 03:28:29PM -0400, Raphaël Beamonte wrote:
> It was just a wrapper around kfree(), so call that instead.

Someone else already did this, sorry.

greg k-h
