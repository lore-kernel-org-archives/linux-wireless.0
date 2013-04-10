Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:65302 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3DJHWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 03:22:37 -0400
Received: by mail-la0-f51.google.com with SMTP id fo12so145633lab.10
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 00:22:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <237CF5B631AA3446BAC55A2F73815CEB07DFE41B@NASANEXD02D.na.qualcomm.com>
References: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
 <1365486778-2336-3-git-send-email-mcgrof@do-not-panic.com>
 <1365490278.8465.1.camel@jlt4.sipsolutions.net> <CAB=NE6XjS7647FADXs7g9P4GmZPpdZmH1A9tNyY9u1_6QHX9og@mail.gmail.com>
 <237CF5B631AA3446BAC55A2F73815CEB07DFE41B@NASANEXD02D.na.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 10 Apr 2013 00:22:15 -0700
Message-ID: <CAB=NE6X9RqZ8p=L3h2dYr1J4ZUw7=GXkYy6wk58nCUf1JM8CSw@mail.gmail.com> (sfid-20130410_092241_245312_0EE04B1C)
Subject: Re: [wireless-regdb] [PATCH 2/3] wireless-regdb: enable VHT80 when
 world roaming
To: "Green, Michael" <green@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"Kandala, Srinivas" <kandala@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
	"Wang, Yunsen" <yunsenw@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 9, 2013 at 6:54 AM, Green, Michael <green@qca.qualcomm.com> wrote:
> If this discussion is about Japan, then yes, VHT160 on the allowed channels for Japan, can be enabled now.

Oh neat, well this is good to know! I sent a patch.

> Or is the question about enabling VHT80 & VHT160 in world mode(s) using passive scanning?

The question was about that.

  Luis
