Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64624 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1J1Dq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 23:46:28 -0400
Received: by ywm3 with SMTP id 3so3294301ywm.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 20:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319743813.32221.3.camel@jlt3.sipsolutions.net>
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	<1317296545-4463-1-git-send-email-helmut.schaa@googlemail.com>
	<1319743813.32221.3.camel@jlt3.sipsolutions.net>
Date: Fri, 28 Oct 2011 05:46:27 +0200
Message-ID: <CAGXE3d8SGPn3hZRR9_PkdM_av33jFfRX1pUw-9hSFbZfLEb9pA@mail.gmail.com> (sfid-20111028_054631_561910_9D6E3E6F)
Subject: Re: [PATCHv2] mac80211: Allow noack flag overwrite for injected frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2011 at 9:30 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-29 at 13:42 +0200, Helmut Schaa wrote:
>> Allow injected unicast frames to be sent without having to wait
>> for an ACK.
>
> Did you ever have a hostapd patch for this?

Yes but I'm traveling right now. But is this still needed since you removed
the monitor interface requirement in hostapd? But at least a rebased
version to make use of your work makes sense ...

Helmut
