Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:16246 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYE2TSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 15:18:40 -0400
Received: by rv-out-0506.google.com with SMTP id l9so4239492rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 12:18:39 -0700 (PDT)
Message-ID: <b6c5339f0805291218y2f54452bu900a51c99c70fe11@mail.gmail.com> (sfid-20080529_211911_193229_9366A379)
Date: Thu, 29 May 2008 15:18:39 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: ath5k can't connect on 5424
Cc: "Jerry Quinn (ibm)" <jlquinn@optonline.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	mickflemm@gmail.com
In-Reply-To: <1212087179.3808.2.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4838A467.1000700@optonline.net>
	 <20080528002814.GF7779@tuxdriver.com> <483EC752.1040609@optonline.net>
	 <1212087179.3808.2.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 2:52 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2008-05-29 at 11:10 -0400, Jerry Quinn (ibm) wrote:
>
>> MAC Version:  2424  (0xa0)
>> MAC Revision: 5424  (0xa3)
>> Warning: Invalid EEPROM Magic number!
>
> If I understand correctly, it means that your device uses a new EEPROM
> layout that hasn't been reverse engineered yet.

Hmm, I get the "Invalid EEPROM" from ath_info as well, but it works
here (same MAC/PHY revisions, different device id and different
regulatory domain).  I guess I'm lucky...

-- 
Bob Copeland %% www.bobcopeland.com
