Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab0JNVo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 17:44:26 -0400
Subject: Re: memory clobber in rx path, maybe related to ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CB5F0D4.4020907@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com>
	 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com>
	 <1286475250.20974.22.camel@jlt3.sipsolutions.net>
	 <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
	 <4CAE13F6.2010003@candelatech.com>
	 <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
	 <4CAE1DFB.303@candelatech.com>
	 <1286479642.20974.32.camel@jlt3.sipsolutions.net>
	 <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
	 <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>
	 <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
	 <4CB378CD.1080800@candelatech.com>
	 <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>
	 <4CB3D598.7050904@candelatech.com>
	 <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
	 <4CB4AA89.1070009@candelatech.com>
	 <AANLkTinpWvMtexFTYVm5rEZY=gY7qY8WxHFtVGB0o6Se@mail.gmail.com>
	 <4CB5E885.7090305@candelatech.com>
	 <AANLkTi=c=w8MvXZ=vqxkRgbXasacQTYXUX8o_zXoZgxC@mail.gmail.com>
	 <4CB5F0D4.4020907@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 23:45:08 +0200
Message-ID: <1287092708.26544.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 10:48 -0700, Ben Greear wrote:

> Here's the slub patch if you are interested in using it yourself:
> https://patchwork.kernel.org/patch/236921/

That really really screams include/linux/stacktrace.h

johannes

