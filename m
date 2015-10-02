Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32377 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbJBGGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 02:06:37 -0400
Date: Fri, 2 Oct 2015 09:06:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	"tony.cho" <tony.cho@atmel.com>, leo.kim@atmel.com
Subject: Re: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
Message-ID: <20151002060622.GK7340@mwanda> (sfid-20151002_080640_853953_FF3B95CB)
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
 <1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com>
 <20151001154015.GJ7340@mwanda>
 <CAKV=isutNb+AeLyZPO9x=h90FeQr8+JfTOFka0bY7SoWofwLbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKV=isutNb+AeLyZPO9x=h90FeQr8+JfTOFka0bY7SoWofwLbQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 07:56:28AM +0900, Chaehyun Lim wrote:
> On Fri, Oct 2, 2015 at 12:40 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Thu, Oct 01, 2015 at 10:43:55PM +0900, Chaehyun Lim wrote:
> >> This patch replaces int8_t with s8 that is a preferred type.
> >>
> >
> > It would be better to just use int.
> 
> I always appreciate your comment. I've sent a patch before after
> changing by int, but it was rejected.

Probably your changelog was bad.  Using s8 is hopefully a sign that you
are doing something very hardware specific.  In this case, it is just a
index.

Write the changelog.  "The int8_t should just be int.  It's used as an
index into an array or -1 for not found."

regards,
dan carpenter

