Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab1JTRlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 13:41:05 -0400
Received: by wwe6 with SMTP id 6so4530304wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 10:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319109412.3959.7.camel@jlt3.sipsolutions.net>
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	<1319072606-28291-6-git-send-email-thomas@cozybit.com>
	<1319109412.3959.7.camel@jlt3.sipsolutions.net>
Date: Thu, 20 Oct 2011 10:41:03 -0700
Message-ID: <CAG6hwVMUhJ=nV=6N+DpoagKWJxMjythPYMYCCzEb=mTr6TfytQ@mail.gmail.com> (sfid-20111020_194114_290746_742C57DA)
Subject: Re: [PATCH 5/6] mac80211: add WMM IE to mesh frames
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 4:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-10-19 at 18:03 -0700, Thomas Pedersen wrote:
>> Include the WMM IE in mesh peering and beacon frames. This is needed
>> tell any potential peers what our WMM / EDCA parameters are.
>
> The goal seems fine but why bother building the WMM IE out of the actual
> TX queue configuration? Shouldn't it normally be the other way around?
> But I have no idea how QoS is supposed to work in a mesh...

I'm not sure what you mean, this is the only way to get the WMM
parameters? Usually these are just set with ieee80211_set_wmm_defaul()
on bringing up the interface.

Thomas
