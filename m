Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43418 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2BIWyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 17:54:14 -0500
Received: by iacb35 with SMTP id b35so3149226iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 14:54:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20120209T131907-783@post.gmane.org>
References: <loom.20120209T131907-783@post.gmane.org>
Date: Thu, 9 Feb 2012 14:54:14 -0800
Message-ID: <CA+yqC4ahPNB=4MTmEk+2Wqpgv6uG24e0cbfSZLj-+bM_yWggjg@mail.gmail.com> (sfid-20120209_235419_504652_6425514A)
Subject: Re: mac80211 fixed rate packet injection
From: Sam Leffler <sleffler@google.com>
To: Lars Bro <larsbro@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 9, 2012 at 4:38 AM, Lars Bro <larsbro@gmail.com> wrote:
> Hi,
>
> At Jan 20, Sam Leffler posted a patch for enabeling packet injection with the
> rate specified in the radiotap message. Did this ever make its way to the
> release, or was it rejected.
>
> I am investigating the feasibility of using such a function for train-wayside
> communication where it is more important that all wayside radios that receive a
> message forward it to the central. This use case does not comply with the
> association-disassociation scheme, as this is one-to-one.

I was asked to remove a WARN_ON but haven't had time to re-spin the
patch.  Feel free to grab it and resubmit...

-Sam
