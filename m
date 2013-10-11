Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37739 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3JKUjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 16:39:13 -0400
Received: by mail-vc0-f169.google.com with SMTP id ib11so3203278vcb.14
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 13:39:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381476265.14293.0.camel@jlt4.sipsolutions.net>
References: <525720d0.6xVLGLwuRrqxqOBI%fengguang.wu@intel.com>
	<20131011014733.GD11191@localhost>
	<CAFSJ42aa_-DTHDxkRDM+0bm9052ree__K54CRm749SeQPDHwRw@mail.gmail.com>
	<1381476265.14293.0.camel@jlt4.sipsolutions.net>
Date: Fri, 11 Oct 2013 21:39:12 +0100
Message-ID: <CAFSJ42Y3x9bzKO8jo-n8Vn7ei38FkYVqW5Gog+_pa_j83ZUXhw@mail.gmail.com> (sfid-20131011_223918_973109_579D85AE)
Subject: Re: [wireless-next:master 82/98] drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24:
 sparse: incorrect type in assignment (different base types)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Do you see the same warning? With the latest sparse i do not see this
warning. I assume this warning depends on sparse version since with my
environment it does not pop up. Also from code perspective it looks
fine. Any ideas?:)

On Fri, Oct 11, 2013 at 8:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-10-11 at 08:19 +0100, Eugene Krasnikov wrote:
>> Hm.. weird. I was sure that i fixed all sparse warnings before
>> contribution. My sparse does not show this warning. Let me try to
>> reproduce this error and come back to you. Thanx for you feedback.
>
>> > reproduce: make C=1 CF=-D__CHECK_ENDIAN__
>
>
>



-- 
Best regards,
Eugene
