Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:3147 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYKRPsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 10:48:38 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1249667ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Nov 2008 07:48:37 -0800 (PST)
Message-ID: <b6c5339f0811180748q354124d2pc3ee9eb3e3cfc745@mail.gmail.com> (sfid-20081118_164843_116416_0E667F77)
Date: Tue, 18 Nov 2008 10:48:36 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Fabio Rossi" <rossi.f@inwind.it>
Subject: Re: ath5k: problems during the connection to a sitecom AP
Cc: linux-wireless@vger.kernel.org,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
In-Reply-To: <200811172120.11299.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200811150207.12084.rossi.f@inwind.it>
	 <200811172120.11299.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 3:20 PM, Fabio Rossi <rossi.f@inwind.it> wrote:
> Which is the best way to proceed with the debug to understand why my
> card isn't going through the authentication-association process with the
> hidden SSID?

You can get a dump of most of the traffic on the wireless medium for ath5k by
using the debugfs files (echo -n "all" > /debug/ath5k/phy0/debug).  It might
miss some packets, get garbled, and chew up a lot of disk in a short period of
time, but it's an alternative to using a second card.  You can log more or
less stuff by using different options, cat the file for a list.

-- 
Bob Copeland %% www.bobcopeland.com
