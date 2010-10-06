Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45849 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab0JFARQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 20:17:16 -0400
Received: by wyb28 with SMTP id 28so6658111wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 17:17:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Oct 2010 17:17:15 -0700
Message-ID: <AANLkTim-W8gs3UOuavAgxfurnFfH3R7M8ZJF_F-n_LFO@mail.gmail.com>
Subject: mac80211 functionality
From: Manu Bansal <manub686@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to do a soft-radio implementation on linux using mac80211
for the parts of 802.11 MAC it implements. It appears that it does not
do the whole MAC, instead only the MLME portion of it, and the core
functions of carrier sensing, backoff etc are still in
firmware/hardware. Is this understanding correct? Are the mac80211
book and code the best references to understand this split of
functionality, or there is a more complete/concise reference?

Thanks,
Manu
