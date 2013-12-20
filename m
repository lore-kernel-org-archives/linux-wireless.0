Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:45258 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3LTIhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 03:37:36 -0500
Received: by mail-we0-f172.google.com with SMTP id p61so2165064wes.31
        for <linux-wireless@vger.kernel.org>; Fri, 20 Dec 2013 00:37:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB122@nasanexd02f.na.qualcomm.com>
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
 <1386077130.4393.21.camel@jlt4.sipsolutions.net> <CAB=NE6Xa-bdLQm8uAg9wCE0fdp4KPBZ46d5FHVHp6wCvN5=dUA@mail.gmail.com>
 <1386145204.4284.4.camel@jlt4.sipsolutions.net> <1386145241.4284.5.camel@jlt4.sipsolutions.net>
 <D19FD2B13A40CD4B8DA64DB9B8F112E93E5CF51C@nasanexd01a.na.qualcomm.com>
 <CAB=NE6VNZDwGj4WWkgCmWxs_xLBZhXn44vo0TEdqo84xsRbZ2Q@mail.gmail.com>
 <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB068@nasanexd02f.na.qualcomm.com>
 <CAB=NE6W3Et-4mDEet5DSDrM=yP60oODvEUGz=RtZj-gDgLNUbw@mail.gmail.com> <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB122@nasanexd02f.na.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 20 Dec 2013 00:37:15 -0800
Message-ID: <CAB=NE6WFOsjRgPyGjudc4c4JVoF-v=nnz2grknOai6=rYxrApA@mail.gmail.com> (sfid-20131220_093739_714511_EDCFE2C0)
Subject: Re: [PATCHv3] cfg80211: add support for frequency interference event
To: "BAHINI, Henri" <hbahini@qca.qualcomm.com>
Cc: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Johnson, Jeff" <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>,
	"Thalappil, Sameer" <sameert@qca.qualcomm.com>,
	"Hussain, Arif" <c_arifh@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 20, 2013 at 12:30 AM, BAHINI, Henri
<hbahini@qca.qualcomm.com> wrote:
> Please do educate us a bit!
> We were not aware of the requirement that all patches contributions to the cfg/nl have to be for driver
> that are already up streamed.

Its not and this will depend on the driver / approach / and intent but
it does help.

> As for our effort for upstreaming our driver, we should take this out of this context since there
> are factors driving this that are completely orthogonal to this discussion.

That's true but it makes it harder for provide examples of the patches
you are introducing. Typically we just remove code that's unused. If
you have no intent on upstreaming then what's the point of doing tons
of review and consideration on API that we deeply care of for
userspace? The patch is debatable as-is already, I've provided my
feedback on it before and if you don't get good feedback from others
and also if some of this is because you are not upstreaming then I'm
trying to highlight for you that perhaps that should be of a little
more importance to you.

  Luis
