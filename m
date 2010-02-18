Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:62393 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0BROpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 09:45:38 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
Date: Thu, 18 Feb 2010 15:41:45 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net> <1266447118.12365.21.camel@mj> <1266494831.6261.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266494831.6261.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201002181541.45835.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Various hardware reports various bogus values, like iwlwifi for
> example reporting the same noise value that it collected after
> a beacon over and over again, or just reporting 127 when it had
> no value. 

I'm not saying that I understand this completely, but for me it 
would make sense to disable iwlwifi's broken noise reporting 
only. No reason to disable it for everyone if some of them are 
broken.

-- 
http://www.holgerschurig.de
