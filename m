Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41513
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXHEMj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 08:39:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Joerg Hermsdorf <joerg.hermsdorf@inf.tu-dresden.de>
Subject: Re: mac80211 and WPA
Date: Sun, 5 Aug 2007 14:39:45 +0200
Cc: linux-wireless@vger.kernel.org
References: <200708051350.57161.joerg.hermsdorf@inf.tu-dresden.de>
In-Reply-To: <200708051350.57161.joerg.hermsdorf@inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708051439.45798.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 05 August 2007, Joerg Hermsdorf wrote:
> My question is now, wasn't the 
> mac80211 subsystem designed to get rid of things like wpa_supplicant?

No, it wasn't.
The supplicant is part of the 802.11 MAC stack.
