Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37356 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbHGIhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 04:37:10 -0400
Date: Fri, 7 Aug 2015 09:37:07 +0100
From: Johannes Postma <jgmpostma@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warning: cast to
 restricted __le16
Message-ID: <20150807083707.GA3923@goofy_linux.Home> (sfid-20150807_103746_866670_A93BB99C)
References: <1438860112-1786-1-git-send-email-jgmpostma@gmail.com>
 <wrfjpp30bo9s.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjpp30bo9s.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/15 at 08:21am, Jes Sorensen wrote:
> 
> Looks OK to me. Probably worth changing the *(usPtr + index) to be
> usPtr[index] as well to make the code easier to read.
> 
> Jes
> 

Thank you for reviewing.  I will make a seperate patch for that.  I will
send it after this one is accepted.  Or should I combine them into a
patch serie?

	Johannes
