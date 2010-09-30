Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39509 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab0I3Vp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 17:45:57 -0400
Received: by iwn5 with SMTP id 5so2934359iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 14:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=CySU4wUoiexZggp9jXco=UMt=Etkm4wp9nAL9@mail.gmail.com>
References: <AANLkTi=CySU4wUoiexZggp9jXco=UMt=Etkm4wp9nAL9@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Sep 2010 14:45:35 -0700
Message-ID: <AANLkTin44kTrBGYgoYohEHN=9HDkkGLORyY_7AyqBBwe@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix for WDS interfaces
To: Bill Jordan <bjordan@rajant.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 2:39 PM, Bill Jordan <bjordan@rajant.com> wrote:
> Splitting previous patch as requested.

Same here

> This patch initializes the rate table for a WDS interface, and
> adds tests to allow WDS packets to pass the xmit and receive
> tests.

It helps if you enumerate these, see and provide a --cover-letter
where you explain more verbose stuff about all 3 patches. See:

http://wireless.kernel.org/en/developers/Documentation/git-guide#Generate_patches

  Luis
