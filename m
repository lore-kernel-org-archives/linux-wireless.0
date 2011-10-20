Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60863 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1JTOY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 10:24:59 -0400
Received: by qyk4 with SMTP id 4so5592404qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 07:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319092629.45912.YahooMailNeo@web29720.mail.ird.yahoo.com>
References: <1319092629.45912.YahooMailNeo@web29720.mail.ird.yahoo.com>
Date: Thu, 20 Oct 2011 10:24:58 -0400
Message-ID: <CAEKwDSCfzzTWhRk9dAWg64TECGA4sur=ZnkYoxNSDBD24n3rwQ@mail.gmail.com> (sfid-20111020_162503_204565_F4921544)
Subject: Re: [ath5k-devel] Support for Linux WiFi stack (+wpa_supplicant) in Android
From: Bob Copeland <me@bobcopeland.com>
To: Dani Camps <danicamps81@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[trimmed CC because none of the mailing lists are the proper place for
this query, and added l-w back]

On Thu, Oct 20, 2011 at 2:37 AM, Dani Camps <danicamps81@yahoo.com> wrote:
> Dear all,
> I would like to ask whether there is support for the Linux Wi-Fi stack (+
> wpa_supplicant) in Android. In http://bobcopeland.com/android_wifi.html it
> is mentioned that the first Android developer phone uses a driver from TI
> that is GPLd and included within mac80211 (wl12xx).

This is not what my (dated) webpage says -- it says that it is
possible to use wl12xx *instead* of the vendor driver with Android.

Have a look at the AOSP code to know for yourself which drivers
Android uses.  Source for drivers is generally available but last time
I looked (and it was quite a while ago) the two main drivers, TI and
broadcom, used their own WEXT ioctls and not cfg80211 etc.  Maybe this
has changed since, I don't know.

> PS: Apologies if this is not the best mailing list for this topic, but
> linux-wireless was returning my emails

Try disabling HTML email.

-- 
Bob Copeland %% www.bobcopeland.com
