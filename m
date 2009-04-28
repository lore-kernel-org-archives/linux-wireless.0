Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58091 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZD1H7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 03:59:13 -0400
Received: by fxm2 with SMTP id 2so370729fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 00:59:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890904271752yd080607x910ef06c45f124d@mail.gmail.com>
References: <5b8543210904220608l484d0d2dv73b0d66cdc167ce@mail.gmail.com>
	 <1240442334.14995.12.camel@localhost.localdomain>
	 <5b8543210904230336j177998c4m1e0af03fbb3584df@mail.gmail.com>
	 <1240483530.30082.178.camel@johannes.local>
	 <5b8543210904230439r45c982fbn66c1a2080adcd442@mail.gmail.com>
	 <43e72e890904271752yd080607x910ef06c45f124d@mail.gmail.com>
Date: Tue, 28 Apr 2009 09:59:12 +0200
Message-ID: <5b8543210904280059v4100bfackdb14ba19eaaeca9a@mail.gmail.com> (sfid-20090428_095918_112941_3E0DD7B3)
Subject: Re: Measure RSSI in adhoc networks
From: Kai Timmer <email@kait.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/28 Luis R. Rodriguez <mcgrof@gmail.com>:
> The ar6000 driver uses wext and not cfg80211 which all new shiny
> mac80211 drivers use. The command Johannes gave you was for cfg80211
> devices.

Thats what i thought. But is there a wext equivalent to these commands?

Greets,
-- 
Kai Timmer
Email : email@kait.de
Jabber: kai@kait.de
