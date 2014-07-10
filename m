Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53659 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaGJG75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 02:59:57 -0400
Message-ID: <53BE39E7.40003@gmail.com> (sfid-20140710_090032_011956_892151BB)
Date: Thu, 10 Jul 2014 12:29:51 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
CC: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: rtl8723au: core: rtw_ap.c - removed NULL
 pointer check before kfree()
References: <1404971737-9737-1-git-send-email-askb23@gmail.com>
In-Reply-To: <1404971737-9737-1-git-send-email-askb23@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thursday 10 July 2014 11:25 AM, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
>
> - as kfree() internally check for NULL, additional check it not
>   required.
>
Sorry - please ignore this patch set, they are already fixed by someone
else recently.
