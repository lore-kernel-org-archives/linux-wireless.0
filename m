Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2047 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0LMTck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 14:32:40 -0500
From: "Brett Rudley" <brudley@broadcom.com>
To: "Sean Paul" <seanpaul@google.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 13 Dec 2010 11:32:26 -0800
Subject: RE: brcm80211 locking up
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE13856A1786@SJEXCHCCR01.corp.ad.broadcom.com>
References: <AANLkTimqTaTJYinS-AyyjwR2hD+zLYuzjC6W0jDXMyB9@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE13856A173D@SJEXCHCCR01.corp.ad.broadcom.com>
 <AANLkTikL8M-nbCuhj4UmYVYEX-5ba2rRthTMFqbYqmwp@mail.gmail.com>
 <4D06670B.90200@lwfinger.net>
 <AANLkTikYRuLi_8iXFnisH6g+-TmKPvvz2ERobq8Bjab9@mail.gmail.com>
In-Reply-To: <AANLkTikYRuLi_8iXFnisH6g+-TmKPvvz2ERobq8Bjab9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Sean Paul
> Sent: Monday, December 13, 2010 10:39 AM
> To: Larry Finger
> Cc: Brett Rudley; linux-wireless@vger.kernel.org
> Subject: Re: brcm80211 locking up
> 
> Hi Larry,
> Thanks for the insight. It's very difficult to debug this since the
> loop is hosing my system, so it's unclear whether an unload/reload
> would fix the issue.
> 
> Brett: Do you know the cause of the loop?

> Two issues:

- Something on your machine is forcing the radio off.  
- The driver isn't handling the radio off condition during load.

The latter is on our todo list and I just haven't had time to deal with yet.

The former is odd... I haven't seen this before (except for when my RF switch was actually off).

What machine is this and have you seen the problem on any other type of machines?  Does it happen all the time, some of the time?

Brett


