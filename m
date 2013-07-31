Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:34080 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3GaUbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 16:31:00 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so1037559wes.11
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 13:30:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJt7DwytQzEMzn9way1z5ag-vo=GsYF72uvmAJEcJeJs=Y-hfw@mail.gmail.com>
References: <CAJt7DwytQzEMzn9way1z5ag-vo=GsYF72uvmAJEcJeJs=Y-hfw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 1 Aug 2013 02:00:39 +0530
Message-ID: <CABPxzYJQB_Lsi4aYkSfvULEgToECAdfZfJCtpm1u4Fo7ibc02g@mail.gmail.com> (sfid-20130731_223104_586417_3AFC4D4B)
Subject: Re: CLI scan tool needed
To: Michael McElroy <mikem388@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 31, 2013 at 11:57 PM, Michael McElroy <mikem388@gmail.com> wrote:
> Using the backports project, I have one of the latest ralink driver
> going on an arm processor running 2.6.29 along with all nl80211 parts.
> Works great, thank you! The last piece I need is to get the to SSID
> list, their security protocols, and signal strength. I'm looking for
> output similar to 'wilist scanning'. 'iw scan' gives a lot of info but
> not quite what I need without a lot of massaging.

"wpa_cli -i <interface> scan"
this should give you the required info, if you are already running the
wpa_supplicant.
