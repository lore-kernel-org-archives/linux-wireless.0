Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37420 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbbHMSWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 14:22:38 -0400
Received: by wibhh20 with SMTP id hh20so85583896wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 11:22:37 -0700 (PDT)
MIME-Version: 1.0
From: Allan Matthew <allanm84@gmail.com>
Date: Thu, 13 Aug 2015 11:22:18 -0700
Message-ID: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com> (sfid-20150813_202241_470933_C37C001E)
Subject: set channel from radiotap headers during injection
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'd like to be able to set the channel information on a per-packet
basis during monitor-mode injection.  Specifically, I would like to be
able to change the channel bandwidth down to half and quarter rates
(my PHY supports this) based on the radiotap header information.
Additionally, if its possible to change the channel itself that would
be desirable.

I've been able to add rate and FEC control to
ieee80211_parse_tx_radiotap, but I'm not sure where to start with
setting channel information. Has anyone been able to do this?  If not,
what do I need to set in order to get per-packet channel control?
