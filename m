Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1KZEbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 23:31:19 -0500
Received: by bke11 with SMTP id 11so5204713bke.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 20:31:18 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 25 Nov 2011 20:31:18 -0800
Message-ID: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com> (sfid-20111126_053129_849976_6A005698)
Subject: Converting ipw2x00 driver to mac80211 framework
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

What do you think is the best way of converting the ipw2x00 driver to
the mac80211 framework?

Is it a good idea to start with the following: split ipw2100.c and
ipw2200.c to the smaller files where each will contain some subset of
functionality (removing code duplication along the way) like in
iwmc3200wifi driver?

Stanislav
