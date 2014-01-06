Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbaAFQiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:38:14 -0500
Message-ID: <1389026290.5891.34.camel@jlt4.sipsolutions.net> (sfid-20140106_173818_577048_480B649D)
Subject: Re: [PATCHv3] cfg80211: add support for frequency interference event
From: Johannes Berg <johannes@sipsolutions.net>
To: "BAHINI, Henri" <hbahini@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Johnson, Jeff" <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>,
	"Thalappil, Sameer" <sameert@qca.qualcomm.com>,
	"Hussain, Arif" <c_arifh@qca.qualcomm.com>
Date: Mon, 06 Jan 2014 17:38:10 +0100
In-Reply-To: <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB122@nasanexd02f.na.qualcomm.com>
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
	 <1386077130.4393.21.camel@jlt4.sipsolutions.net>
	 <CAB=NE6Xa-bdLQm8uAg9wCE0fdp4KPBZ46d5FHVHp6wCvN5=dUA@mail.gmail.com>
	 <1386145204.4284.4.camel@jlt4.sipsolutions.net>
	 <1386145241.4284.5.camel@jlt4.sipsolutions.net>
	 <D19FD2B13A40CD4B8DA64DB9B8F112E93E5CF51C@nasanexd01a.na.qualcomm.com>
	 <CAB=NE6VNZDwGj4WWkgCmWxs_xLBZhXn44vo0TEdqo84xsRbZ2Q@mail.gmail.com>
	 <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB068@nasanexd02f.na.qualcomm.com>
	 <CAB=NE6W3Et-4mDEet5DSDrM=yP60oODvEUGz=RtZj-gDgLNUbw@mail.gmail.com>
	 <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB122@nasanexd02f.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-12-20 at 08:30 +0000, BAHINI, Henri wrote:
> Please do educate us a bit!
> We were not aware of the requirement that all patches contributions to
> the cfg/nl have to be for driver that are already up streamed.

You're adding code that needs to be maintained, thought about when
changing other things, etc. I don't see why we as the community should
shoulder that burden if you're not even willing to upstream the code
using it. It feels like you're just dumping code that you happen to need
today over the wall.

We've never really had to even consider this situation because you're
the first to actively work on cfg80211/nl80211 while apparently not even
thinking about upstreaming your driver!

johannes

