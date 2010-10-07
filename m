Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0JGTRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 15:17:20 -0400
Subject: Re: memory clobber in rx path, maybe related to ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAE1C02.7090405@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com>
	 <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
	 <4CAB5F3D.9060201@candelatech.com>
	 <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
	 <4CAB627F.8020804@candelatech.com>
	 <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
	 <4CAB64AD.4080105@candelatech.com>
	 <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
	 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com>
	 <1286475250.20974.22.camel@jlt3.sipsolutions.net>
	 <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
	 <4CAE13F6.2010003@candelatech.com>
	 <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
	 <4CAE1553.1070900@candelatech.com>  <4CAE1C02.7090405@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 21:17:17 +0200
Message-ID: <1286479037.20974.30.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 12:14 -0700, Ben Greear wrote:
> > I'll start a compile of vanilla wireless-testing + scan fix as well.
> 
> Well, vanilla + scan patch locked pretty hard when I started the script.
> 
> I was able to get sysrq to dump the locks, but it didn't seem to complete
> that and couldn't even dump more sysrq info after that.
> 
> Might be something entirely different, of course, and no idea if
> this lock dump shows any real problem.

Don't see any issues in this part of the dump -- heavy contention on the
RTNL but that was expected with your usage.

johannes

