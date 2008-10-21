Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:47402 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbYJUX1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 19:27:34 -0400
Received: by gxk9 with SMTP id 9so6516427gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 16:27:33 -0700 (PDT)
Message-ID: <43e72e890810211627v686d327bv3fc3bd766e1c5b85@mail.gmail.com> (sfid-20081022_012751_760696_F8650673)
Date: Tue, 21 Oct 2008 16:27:33 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"reinette chatre" <reinette.chatre@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1224630716.9386.117.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1224613633.10863.43.camel@rc-desk>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1ba2fa240810211523x2327351fxf8c1c54207d7706b@mail.gmail.com>
	 <1224630116.9386.108.camel@californication>
	 <43e72e890810211609t4ed76b3cq76d400d4a7c025e2@mail.gmail.com>
	 <1224630716.9386.117.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 4:11 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> > as long as the firmware is a file on the filesystem, it is the old
>> > userspace. It is simpler to update a firmware file (in this case
>> > installing a new one) then installing additional software, but that
>> > doesn't change anything.
>> >
>> > Our current problem is that our firmware is still not part of the
>> > firmware tree David Woodhouse is maintaining. Then we could link it
>> > together with the kernel tree. And yes, that is license issue, but it is
>> > one that can be solved.
>>
>> What license issue BTW?
>
> about putting our ucode into the linux-firmware.git tree?

Yeah, what's wrong with the license used right now?

  Luis
