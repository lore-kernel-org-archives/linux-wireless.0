Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62447 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3JBLoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 07:44:30 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so917291pad.37
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 04:44:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfdy2VdnTa55YJMQHTc+bj-oBUuSb1rT0nKbLKK7BZrSjQ@mail.gmail.com>
References: <1378044951-13682-1-git-send-email-arik@wizery.com> <CA+XVXfdy2VdnTa55YJMQHTc+bj-oBUuSb1rT0nKbLKK7BZrSjQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 2 Oct 2013 14:44:14 +0300
Message-ID: <CA+XVXffqJ1C4s0zhrpvDK+Zaxu6Rv0b126FQjCcD7mhGZQK9bg@mail.gmail.com> (sfid-20131002_134433_390696_38FB166B)
Subject: Re: [PATCH v2] mac80211: implement STA CSA for drivers using channel contexts
To: Johannes Berg <johannes.berg@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 29, 2013 at 10:06 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Sun, Sep 1, 2013 at 5:15 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> Limit the current implementation to a single channel context used by
>> a single vif, thereby avoiding multi-vif/channel complexities.
>>
>> Reuse the main function from AP CSA code, but move a portion out in
>> order to fit the STA scenario.
>>
>> Add a new mac80211 HW flag so we don't break devices that don't support
>> channel switch with channel-contexts. The new behavior will be opt-in.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>
> Ping?

Ping 2 :)
(Just saw your email on the list urging pings)

Arik
