Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:21066 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZI2G7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 02:59:38 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Firmware versioning best practices
Date: Tue, 29 Sep 2009 08:59:24 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	Bob Copeland <me@bobcopeland.com>
References: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com>
In-Reply-To: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909290859.25075.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Or shall we have the same firmware filename and simply query
> the firmware for a map of capabilities? Any other ideas?

Don't put the version into the filename. This is not a common 
practice for Linux / BSD / whatever systems. Usually you have 
a "kmail" file, not a kmail3.5, kmail4.0 and kmail4.2 file.

Versions or capability maps can be stored inside the firmware and 
queried at load time. E.g. the libertas driver does it that way.

If you make your firmware redistributable (which I recommend), 
the version will also be stored in the package metadata, e.g. 
the rpm or deb file and the infrastructure for rpm/yum deb/apt.

-- 
http://www.holgerschurig.de
