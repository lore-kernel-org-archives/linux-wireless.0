Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35932 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbbEUSbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 14:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <20150521182356.GD23057@wotan.suse.de>
References: <20150520140426.GB126473@ubuntu-hedt> <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost> <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost> <20150521061453.GC30864@kroah.com>
 <1432213521.4230.43.camel@linux.vnet.ibm.com> <20150521154508.GA11821@kroah.com>
 <1432224181.8004.7.camel@intel.com> <20150521170236.GC12932@kroah.com> <20150521182356.GD23057@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Thu, 21 May 2015 11:30:51 -0700
Message-ID: <CAB=NE6VFK8eNyP-vmme6mSLtSPFqNj=_K5fDLzHcGU33LVSUGg@mail.gmail.com> (sfid-20150521_203129_816342_CDEB5A12)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seth.forshee@canonical.com" <seth.forshee@canonical.com>,
	"zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>,
	"mricon@kernel.org" <mricon@kernel.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"jlee@suse.de" <jlee@suse.de>, "kyle@kernel.org" <kyle@kernel.org>,
	"gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 11:23 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> Sounds like a great project if you have the freedom and flexibility to
> enable such hardware component. Now, if you can save a few bucks on it
> per unit, how much would it be exactly? Just curious.

Also, another thing to think about:

How many crypto checking devices do you need? If your motherboard
already comes with one, why not trust / rely on it once for all device
firmware? I realize silicon folks want to sell you kitchen sinks with
granite counter tops included, but if working on spiffy open designs,
I figure having the freedom to trust / rely on some other device's
components might yield pretty cheap and flexible solutions.

 Luis
