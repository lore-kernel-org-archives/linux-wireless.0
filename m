Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62603 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0HRTbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 15:31:55 -0400
Received: by iwn7 with SMTP id 7so928845iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Aug 2010 12:31:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282159855.27858.1.camel@wwguy-huron>
References: <1282153819-27781-1-git-send-email-wey-yi.w.guy@intel.com>
	<1282153819-27781-3-git-send-email-wey-yi.w.guy@intel.com>
	<AANLkTikEKbHNtG0A=QdoxytSyBpG247=zdXOj1FmQ8Lw@mail.gmail.com>
	<1282159855.27858.1.camel@wwguy-huron>
Date: Wed, 18 Aug 2010 21:31:54 +0200
Message-ID: <AANLkTikxidtUbOWcH0teXv2ZKCD=-DLC_xu3=gvCdmGz@mail.gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: use long monitor timer to avoid un-necessary reload
From: drago01 <drago01@gmail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 18, 2010 at 9:30 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> On Wed, 2010-08-18 at 11:50 -0700, drago01 wrote:
>> On Wed, Aug 18, 2010 at 7:50 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
>> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>> >
>> > For 5000 series of devices, use long monitor timer to check
>> > stuck tx queues.
>> >
>> > 5000 series device, it is being reported firmware got reload more
>> > often than necessary, so extend the timer to avoid un-necessary reload.
>>
>> What about iwl5300 ?
>> As I noted in the other thread my 5300 was affected by said issue and
>> increasing the timeout fixed it.
>>
> I am not aware of 5300 also having similar issues;

http://marc.info/?l=linux-wireless&m=127974234430167&w=2

(This mail and follow ups).

> I all submit follow
> up patch to extend the timeout value for 5300 device.

Thanks
