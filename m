Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:38082 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZIYUwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 16:52:55 -0400
Received: by vws41 with SMTP id 41so1868372vws.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 13:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909252054.19762.rene.mayrhofer@gibraltar.at>
References: <200909252054.19762.rene.mayrhofer@gibraltar.at>
Date: Fri, 25 Sep 2009 16:52:58 -0400
Message-ID: <b6c5339f0909251352s4c30323awa588dd2f9f0d1af5@mail.gmail.com>
Subject: Re: Massive packet loss with ath9k, AR9280, hostapd in 802.11n mode
From: Bob Copeland <me@bobcopeland.com>
To: Rene Mayrhofer <rene.mayrhofer@gibraltar.at>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 2:54 PM, Rene Mayrhofer
<rene.mayrhofer@gibraltar.at> wrote:

I'll take a stab at this one, someone else can try the other ath9k-related
questions.

> 4. How do I tell CRDA to load frequency definitions for my location (AT)
> instead of the default (US)? I might be blind, stupid, or both, but using the
> slightly conflicting documentation available on various Wikis, I was unable to
> change this. I have read that some chipsets are hard-wired for one location
> and can't be changed, but couldn't find out if mine is (it was bought in
> Europe, so shouldn't be locked to US in any case). An RTFM (with an up-to-date
> pointer, preferrably for Debian/Ubuntu) in this matter would be highly
> appreciated.

"iw reg set XX", but read this first:

http://wireless.kernel.org/en/users/Drivers/ath
http://wireless.kernel.org/en/developers/Regulatory

In short, it depends on what's in your EEPROM.

-- 
Bob Copeland %% www.bobcopeland.com
