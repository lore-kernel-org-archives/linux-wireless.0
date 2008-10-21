Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59052 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYJUXe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 19:34:27 -0400
Received: by gxk9 with SMTP id 9so6523735gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 16:34:26 -0700 (PDT)
Message-ID: <43e72e890810211634q3d321500p1c40c6e73587b48@mail.gmail.com> (sfid-20081022_013429_827675_1258868B)
Date: Tue, 21 Oct 2008 16:34:25 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"reinette chatre" <reinette.chatre@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1224631902.9386.121.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1224613633.10863.43.camel@rc-desk>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1ba2fa240810211523x2327351fxf8c1c54207d7706b@mail.gmail.com>
	 <1224630116.9386.108.camel@californication>
	 <43e72e890810211609t4ed76b3cq76d400d4a7c025e2@mail.gmail.com>
	 <1224630716.9386.117.camel@californication>
	 <43e72e890810211627v686d327bv3fc3bd766e1c5b85@mail.gmail.com>
	 <1224631902.9386.121.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 4:31 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> >> > as long as the firmware is a file on the filesystem, it is the old
>> >> > userspace. It is simpler to update a firmware file (in this case
>> >> > installing a new one) then installing additional software, but that
>> >> > doesn't change anything.
>> >> >
>> >> > Our current problem is that our firmware is still not part of the
>> >> > firmware tree David Woodhouse is maintaining. Then we could link it
>> >> > together with the kernel tree. And yes, that is license issue, but it is
>> >> > one that can be solved.
>> >>
>> >> What license issue BTW?
>> >
>> > about putting our ucode into the linux-firmware.git tree?
>>
>> Yeah, what's wrong with the license used right now?
>
> this is not my authority, but as far as I understand it, it is fine, but
> someone inside Intel actually has to give green lights for it. And that
> is neither David or me.

Ah ok :) thanks for the clarification, red tape then.

  Luis
