Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35180 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbbJSPJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 11:09:19 -0400
Date: Mon, 19 Oct 2015 18:09:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH V2 01/40] staging: wilc1000: rename ssidLen of struct
 join_bss_param
Message-ID: <20151019150910.GX7289@mwanda> (sfid-20151019_170927_386980_99795F70)
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
 <20151017045907.GA6504@kroah.com>
 <5624481A.2050405@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5624481A.2050405@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2015 at 10:32:10AM +0900, Tony Cho wrote:
> 
> 
> On 2015년 10월 17일 13:59, Greg KH wrote:
> >On Fri, Oct 16, 2015 at 01:37:31PM +0900, Tony Cho wrote:
> >>From: Leo Kim <leo.kim@atmel.com>
> >>
> >>This patch renames ssidLen of struct join_bss_param to ssid_len
> >>to avoid CamelCase naming convention.
> >>
> >>Signed-off-by: Leo Kim <leo.kim@atmel.com>
> >>Signed-off-by: Tony Cho <tony.cho@atmel.com>
> >>---
> >>  drivers/staging/wilc1000/host_interface.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >Doesn't apply, I missed that you sent this as v2, why did you do that?
> >What was wrong with v1?
> 
> This series of V2 includes Dan's suggestion, we don't have to add one blank line between malloc and null check if-statement.
> 

I said that that patch was fine.  I was intending that you change all of
them in a later patch.  I really try to not delay progress with small
review comments.

regards,
dan carpenter

