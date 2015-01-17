Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbAQWTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2015 17:19:51 -0500
Date: Sat, 17 Jan 2015 13:58:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: core: rtw_cmd.c:  Remove some unused
 functions
Message-ID: <20150117215816.GA17730@kroah.com> (sfid-20150117_232013_880056_BBB9FCE9)
References: <1419095413-10163-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419095413-10163-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 20, 2014 at 06:10:13PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> rtw_set_ch_cmd23a() rtw_cmd_clr_isr23a()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c    |   61 ---------------------------
>  drivers/staging/rtl8723au/include/rtw_cmd.h |    2 -
>  2 files changed, 63 deletions(-)

This patch doesn't apply :(
