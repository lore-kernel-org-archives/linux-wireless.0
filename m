Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38736 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752465AbdEMLkP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 07:40:15 -0400
Received: by mail-wm0-f43.google.com with SMTP id v15so4643616wmv.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 04:40:14 -0700 (PDT)
Subject: Re: Participation in common kernel API recommendation?
To: Eric Schultz <eschultz@prplfoundation.org>,
        linux-wireless@vger.kernel.org
References: <3ae60be2-63b5-1409-8b6c-f0a363c7968b@prplfoundation.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <42258cf0-ed93-4d18-8114-012d1d227532@broadcom.com> (sfid-20170513_134022_183968_4CC84693)
Date: Sat, 13 May 2017 13:40:13 +0200
MIME-Version: 1.0
In-Reply-To: <3ae60be2-63b5-1409-8b6c-f0a363c7968b@prplfoundation.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-5-2017 23:28, Eric Schultz wrote:
> Hey all,
> 
> My name’s Eric Schultz, I’m the Community Manager at prpl Foundation
> (https://prpl.works <https://prpl.works/>). prpl Foundation has an
> effort, called the Low-Level Common API subcommittee, led by Felix
> Fietkau of OpenWrt/LEDE and Wouter Cloutens of SoftAtHome to work with
> chipset vendors, OEMs and carriers to improve support for and usage of
> common kernel APIs. Our first targeted API is cfg80211 and we’ve written
> a recommendation draft. While we we’re mostly encouraging all the
> parties to simply use cfg80211 and participate in the community, we’d
> like to get feedback from some members of the Linux Wireless community
> before publishing. After all, we don’t want to make a recommendation
> that would cause problems for the community!

Hi Eric,

Just clarifying the terminology. cfg80211 is the kernel module that
provides the nl80211 API to user-space, which is a netlink protocol family.

> Would any members be interested in spending a one hour meeting with the
> subcommittee to give some feedback on the recommendation? If so, please
> let me know.

Just throwing a wild idea at you. In the spirit of how the community
works why not post it (on refer to some public link) on the mailing list
for review to get the feedback.

Regards,
Arend
