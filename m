Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:46415 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYELJXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 05:23:34 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3379336waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 02:23:34 -0700 (PDT)
Message-ID: <1ba2fa240805120223m2ff24028j5f5f29a0e40153e2@mail.gmail.com> (sfid-20080512_112338_786807_1B32DF3A)
Date: Mon, 12 May 2008 12:23:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Mirco Tischler" <mt-ml@gmx.de>
Subject: Re: BUG: scheduling while atomic: events/1/10/0x00000002 on linux-next
Cc: lkml <linux-kernel@vger.kernel.org>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Emmanuel Grumbach" <egrumbach@gmail.com>
In-Reply-To: <1210534778.5052.3.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210524139.17521.5.camel@mtlp.tischlernetz>
	 <1ba2fa240805111226s6f900015n4144f5411957ef2a@mail.gmail.com>
	 <1210534778.5052.3.camel@mtlp.tischlernetz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 11, 2008 at 10:39 PM, Mirco Tischler <mt-ml@gmx.de> wrote:
>> What exact git tree is this?
>>   iwlcore:iwl_send_cmd_sync+0x154/0x24b waits for event so something
>> has changed in mac80211. Need to see the code.
>>
>> Thanks
>> Tomas
>>
> This is Stephen's linux-next tree from 2008-05-09. Checkout tag
> next-20080509.

Reproduced, we will release patch into wireless-testing.git

Thanks for reporting
Tomas
