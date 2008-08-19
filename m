Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:32032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYHSMfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 08:35:45 -0400
Received: by ug-out-1314.google.com with SMTP id c2so471373ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 05:35:43 -0700 (PDT)
Message-ID: <1ba2fa240808190535g513cd0das37f436e756d0bc60@mail.gmail.com> (sfid-20080819_143552_037824_2E98BAB4)
Date: Tue, 19 Aug 2008 15:35:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: Userspace client MLME and BSSID-mismatch filtering for scans
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080818190829.GB4809@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080818164741.GA4809@jm.kir.nu> <20080818190829.GB4809@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2008 at 10:08 PM, Jouni Malinen <j@w1.fi> wrote:
> On Mon, Aug 18, 2008 at 07:47:42PM +0300, Jouni Malinen wrote:
>> I'm trying to get userspace client MLME working again and the next
>> blocker seems to be in Probe Response frames being dropped during
>> scanning
>
> I got the userspace client MLME working with the current wpa_supplicant
> 0.6.x git version and using -Dnl80211. mac80211 needs two changes for
> this to work: cfg80211 vif configuration option for enabling userspace
> MLME (I'll send an updated patch for this) and workaround/fix for
> ProbeResp frames (BSSID-mismatch) dropping during scan (works with the
> patch I sent in the previous message in this thread or alternatively,
> could add a mechanism for letting mac80211 know when userspace MLME is
> doing scanning if that is considered more preferable; that extension
> would add on top of the vif configuration patch to bring in extra
> parameters for indicating scan state).
>

What are benefits this type of scanning?  Is this sultion you are
looking for or this just should bridge temporal lack of  nl80211 API
for scanning?
Thanks
Tomas
