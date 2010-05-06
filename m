Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:60091 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab0EFSMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:12:16 -0400
Received: by ywh36 with SMTP id 36so164401ywh.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 11:12:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100505120131.2b9f4e06@atom.pigiron.org>
References: <20100505120131.2b9f4e06@atom.pigiron.org>
Date: Thu, 6 May 2010 11:12:15 -0700
Message-ID: <t2j446ae9281005061112z6eee4126z673947eb02dc4f12@mail.gmail.com>
Subject: Re: The case of the bogus SSID
From: Steve deRosier <steve@cozybit.com>
To: pigiron <pigiron@gmx.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 5, 2010 at 10:01 AM, pigiron <pigiron@gmx.com> wrote:
> I noticed that decimal 52 is assigned to WLAN_EID_MESH_ID in the ieee80211.h file, and recently the same 52 was also assigned to WLAN_EID_NEIGHBOR_REPORT in the same enumerated ieee80211_eid{} structure.
>

I can't answer the rest of your question, but AFAIK, the element IDs
for 802.11s mesh haven't been approved yet as the 802.11s draft
contains a note to that effect.  The current ANA database sheet I
could find (Feb 2010) does have 52 assigned to Neighbor Report, and
the mesh element IDs are nowhere to be found.

- Steve
