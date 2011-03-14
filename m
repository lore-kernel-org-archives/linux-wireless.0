Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44494 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab1COTB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 15:01:57 -0400
Date: Mon, 14 Mar 2011 16:02:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org,
	=?iso-8859-1?Q?Fran=E7ois?= Valenduc
	<francois.valenduc@tvcablenet.be>
Subject: Re: [RFC/RFT 0/11] rtlwifi: rtl8192se: Merge new driver
Message-ID: <20110314200214.GC2525@tuxdriver.com>
References: <4d732b50.jiYdcLhAW6PZf7C3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4d732b50.jiYdcLhAW6PZf7C3%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 06, 2011 at 12:36:00AM -0600, Larry Finger wrote:
> This set of patches merges a new driver for the RTL8192SE device.
> 
>  1/11: rtlwifi: rtl8192se: Merge routines for dynamic management
>  2/11: rtlwifi: rtl8192se: Merge routines for firmware loading
>  3/11: rtlwifi: rtl8192se: Merge routines for device specific hardware access
>  4/11: rtlwifi: rtl8192se: Merge routines for LED handling
>  5/11: rtlwifi: rtl8192se: Merge routines for PHY handling
>  6/11: rtlwifi: rtl8192se: Merge register definition routine
>  7/11: rtlwifi: rtl8192se: Merge routines for RF handling
>  8/11: rtlwifi: rtl8192se: Merge routines for initialization
>  9/11: rtlwifi: rtl8192se: Merge routines for tables
> 10/11: rtlwifi: rtl8192se: Merge routines for TX and RX
> 11/11: rtlwifi: rtl8192se: Modify rtlwifi routines to handle rtl8192se add Makefile and Kconfig
> ---
> 
> John,
> 
> This driver is the one you asked about a couple of days ago. If possible to get this in
> 2.6.39, please do so.
> 
> Larry

This driver looks acceptable (certainly better than no driver),
but patch 11 (v2) doesn't seem to apply.  Did you get a
resolution to the problems reported by François Valenduc
<francois.valenduc@tvcablenet.be>?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
