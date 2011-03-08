Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56016 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab1CHHnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 02:43:55 -0500
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: Powersave broken on p54
References: <1299003142.6461.12.camel@maggie>
	<201103021813.52719.chunkeey@googlemail.com>
	<1299086257.13604.17.camel@marge>
	<201103021918.30528.chunkeey@googlemail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Mar 2011 09:43:53 +0200
In-Reply-To: <201103021918.30528.chunkeey@googlemail.com> (Christian Lamparter's message of "Wed\, 2 Mar 2011 19\:18\:30 +0100")
Message-ID: <87oc5m2h1i.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> On Wednesday 02 March 2011 18:17:37 Michael Buesch wrote:
>> On Wed, 2011-03-02 at 18:13 +0100, Christian Lamparter wrote:
>> > sure there was the rssi->dbm update (I hope you've already updated
>> > your eeprom image.)
>> 
>> What change to the eeprom is needed? My eeprom doesn't
>> contain any rssi info (see recent NULL ptr fix).
>
> I think you should (re-)add it, I don't know what the
> firmware is doing with it, but maybe Kalle knows more?

Most probably it's just to get good rssi values for received frames
which is passed to the host. I doubt that the rssi calibration values
are used anything useful inside the firmware. But as always, anything
is possible :)

-- 
Kalle Valo
