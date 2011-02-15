Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37868 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1BOOun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 09:50:43 -0500
Received: by qwa26 with SMTP id 26so183175qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 06:50:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297361481.30218.31.camel@maggie>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	<AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	<1297288286.9734.28.camel@maggie>
	<AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	<4D5320AA.5020405@lwfinger.net>
	<1297315457.12795.40.camel@dev.znau.edu.ua>
	<1297333256.30218.10.camel@maggie>
	<1297359641.15805.38.camel@dev.znau.edu.ua>
	<1297361481.30218.31.camel@maggie>
Date: Tue, 15 Feb 2011 15:50:42 +0100
Message-ID: <AANLkTi=vp2cCsSJNv1+G2kWxTOL4Y7Tq8TVAMN_cAGQ6@mail.gmail.com>
Subject: Re: SSB AI support code ([RFC] v2)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/10 Michael Büsch <mb@bu3sch.de>:
> You're actually abusing the ops structure. The ops structure is meant
> to abstract the SSB backplane from its host bus. It is _not_ meant
> to abstract the SSB backplane itself. Your patches mix that up. It's
> an abstraction layer violation, which my proposal avoids completely.

After some reading, learning, I think I generally agree with Michael.

George: I like you consider separated bus driver now. Please let us
know when you design something!

-- 
Rafał
