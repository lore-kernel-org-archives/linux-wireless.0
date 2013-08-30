Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47028 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3H3AeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 20:34:13 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so1142294pbc.35
        for <linux-wireless@vger.kernel.org>; Thu, 29 Aug 2013 17:34:13 -0700 (PDT)
MIME-Version: 1.0
From: Blaise Gassend <blaise@suitabletech.com>
Date: Thu, 29 Aug 2013 17:33:53 -0700
Message-ID: <CAPvVjitJwgOH-LtGmbee22wnj=JPjeOY=6RDkBX4DVh_Aea+fg@mail.gmail.com> (sfid-20130830_023418_065102_30C29D98)
Subject: 
To: linux-wireless@vger.kernel.org
Cc: Catalin Drula <catalin@suitabletech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Tracking down a customer problem, I recently discovered that Linux
does not currently support hidden SSIDs on DFS channels. As far as I
can tell, there isn't a fundamental reason for this. You could switch
to a frequency, listen for a beacon, once you see the beacon send a
directed probe, and listen for responses. I'm sure there are folks on
this list who have thought about this issue...

- Are there any reasons you know of why my proposed strategy would not
work from a regulatory or technical point of view?

- If a patch were prepared, is this something that would be considered
for mainstream inclusion?

I know that hidden SSIDs are a bad idea. But some customers can be
hard to convince, and dealing with customers who have hidden SSIDs on
DFS channels can be a support burden. If we can make it just work for
them then our life is that much easier.

Regards,
Blaise
