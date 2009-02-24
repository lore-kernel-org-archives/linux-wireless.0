Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:49177 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbZBXTqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 14:46:13 -0500
Received: by wf-out-1314.google.com with SMTP id 28so3265419wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 11:46:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090224145532.GB3536@tuxdriver.com>
References: <200902241531.50649.helmut.schaa@gmail.com>
	 <20090224145532.GB3536@tuxdriver.com>
Date: Tue, 24 Feb 2009 11:46:11 -0800
Message-ID: <43e72e890902241146t6c0cd241qd7488b9646aecbe3@mail.gmail.com> (sfid-20090224_204623_262003_21E98A5C)
Subject: Re: [PATCH] crda: allow loading of regulatory.bin from /lib/crda in
	addition to /usr/lib/crda
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 6:55 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Feb 24, 2009 at 03:31:50PM +0100, Helmut Schaa wrote:
>> As crda is typically installed in /sbin it might be worth to install
>> regulatory.bin into /lib/crda instead of /usr/lib/crda. Hence, exten=
d
>> crda to try both paths for loading the database.
>>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Thanks Helmut, applied.

> Is it worthwhile to add /usr/local/lib/crda too? =C2=A0That way a use=
r could
> override the regulatory.bin without disturbing the distro's packaging=
=2E

Added that as well and added that first in the path.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
