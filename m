Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbbGOC2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 22:28:02 -0400
Date: Tue, 14 Jul 2015 19:28:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] staging: vt6655: Fix missing power saving support
Message-ID: <20150715022801.GA7780@kroah.com> (sfid-20150715_042806_460147_F22AE6B7)
References: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com>
 <1436457687-3113-2-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436457687-3113-2-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 09, 2015 at 05:01:25PM +0100, Malcolm Priestley wrote:
> Add IEEE80211_HW_SUPPORTS_PS to ieee80211_hw flags
> enabling this feature.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> ---
> v2 rebased for 4.2

Ah, nevermind, you did this already, now applied.

Sorry for the noise,

greg k-h
