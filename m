Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36216 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaBRWW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 17:22:27 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so12597791lab.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 14:22:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A03336BCAF@HASMSX106.ger.corp.intel.com>
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <1389801162-14488-5-git-send-email-ilan.peer@intel.com> <20140125002002.GB28512@garbanzo.do-not-panic.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A03336BCAF@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 14:22:05 -0800
Message-ID: <CAB=NE6XgDSLE__a3Ud2yWVCkqxudA5_NGBaN9R_aqfBsF93bwQ@mail.gmail.com> (sfid-20140218_232231_357778_EA8732D2)
Subject: Re: [PATCH v2 4/6] cfg80211: Add an option to hint indoor operation
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 26, 2014 at 2:11 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
> Actually, when the hint is processed, REG_REQ_ALREADY_SET is returned, so the request is immedialty freed, and the last request is not updated. I thought that this should suffice. Do you see any other issue with this?

Yeah that seems hackish -- please add another enum entry and document
it to allow further hints of similar kind to be added.

  Luis
