Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:65446 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYG3Owc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 10:52:32 -0400
Received: by nf-out-0910.google.com with SMTP id d3so27523nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 07:52:30 -0700 (PDT)
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Luis Carlos Cobo <luisca@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20080730143003.GB19408@tuxdriver.com>
References: <200807281544.33509.mb@bu3sch.de>
	 <1217253397.6364.2.camel@localhost> <200807281600.39103.mb@bu3sch.de>
	 <1217257174.28198.27.camel@localhost.localdomain>
	 <1217257628.15381.2.camel@johannes.berg>
	 <1217258040.28198.40.camel@localhost.localdomain>
	 <1ba2fa240807280858o4020fec8k4c287567dff177ca@mail.gmail.com>
	 <1217262158.28198.44.camel@localhost.localdomain>
	 <1217416640.6379.144.camel@localhost>
	 <1217417721.11432.21.camel@localhost.localdomain>
	 <20080730143003.GB19408@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 16:52:22 +0200
Message-Id: <1217429542.6379.161.camel@localhost> (sfid-20080730_165238_949121_50F37583)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 10:30 -0400, John W. Linville wrote:
> I'm with Dan -- use all zeroes.

It looks like most people prefer all zeroes, I'll go for that.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


