Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 13.mo5.mail-out.ovh.net ([87.98.182.191]:46774 "EHLO
	13.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975AbbD1LGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 07:06:05 -0400
Received: from mail624.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo5.mail-out.ovh.net (Postfix) with SMTP id 201A4FF9C98
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2015 10:38:51 +0200 (CEST)
Message-ID: <553F4716.6040707@effinnov.com> (sfid-20150428_130626_335731_2D041963)
Date: Tue, 28 Apr 2015 10:38:46 +0200
From: =?UTF-8?B?Q2zDqW1lbnQgUGVycm9jaGF1ZA==?=
	<clement.perrochaud@effinnov.com>
MIME-Version: 1.0
To: Valentin Rothberg <valentinrothberg@gmail.com>
CC: sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
Subject: Re: NFC: CONFIG_NFC_DEBUG not defined
References: <CAD3Xx4+vRhswKAbpHnrYQMRNKOppOQzgFOgoJw_1iAfK4baCtQ@mail.gmail.com> <CAD3Xx4+eZOrgm_ae9UeUWB+EfUdi5B1jqs1R-CxYzYZ5AvHyfQ@mail.gmail.com> <553F4382.2070402@effinnov.com> <CAD3Xx4LYkvACWZwy5TZUK6eOTLFv78pBCtZFv3y6Tfsm7vuy=w@mail.gmail.com>
In-Reply-To: <CAD3Xx4LYkvACWZwy5TZUK6eOTLFv78pBCtZFv3y6Tfsm7vuy=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/2015 10:35 AM, Valentin Rothberg wrote:
> DEBUG is not used in any of the files in drivers/nfc/ so I think we
> can safely remove the two lines from the Makefiles.  Do you want me to
> prepare a patch?

That would be great, thanks.

-- 
Clément Perrochaud

Eff'Innov Technologies
Caen, Aix-En-Provence, Grenoble

Eff'Innov Technologies
Campus EffiScience
2, Esplanade Anton Philips
14460 Colombelles, FRANCE

http://www.effinnov.com
