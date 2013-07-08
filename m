Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:46869 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3GHUYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 16:24:08 -0400
Received: by mail-la0-f53.google.com with SMTP id fs12so4137181lab.40
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jul 2013 13:24:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMcMvsiQb=byYEV4z2aZUYCLjRmqJUm_SQrUrOPUXrrfkcjeLA@mail.gmail.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
 <1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com> <CAMcMvsiQb=byYEV4z2aZUYCLjRmqJUm_SQrUrOPUXrrfkcjeLA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 8 Jul 2013 13:23:45 -0700
Message-ID: <CAB=NE6XFY1po10NZOCqTAbBWT6kvpmS67pRnj9CDtBUQTt_Pqw@mail.gmail.com> (sfid-20130708_222411_786710_E58F422A)
Subject: Re: [RFC 42/53] wireless-regdb: ID, Indonesia - enable 5 GHz and VHT80
To: Paul Stewart <pstew@chromium.org>
Cc: John Linville <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 4, 2013 at 10:51 AM, Paul Stewart <pstew@chromium.org> wrote:
> On Wed, Jul 3, 2013 at 6:04 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>>
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> Pursuant to:
>>
>> http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf,
>>
>> provide a 5GHz rule for Indonesian regulatory domain. QCA has
>> also verified VHT80 can be enabled. Patch originally posted by
>> Paul Stewart <pstew@chromium.org>, I just modified to enable 80 MHz
>> bandwidth.
>>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> Signed-off-by: Paul Stewart <pstew@chromium.org>

Given I've been promoting the idea of taking the Linux kernel DCO and
making it a standalone project [0] it is critical for me to promote
proper usage of the Signed-off-by tag. In this case it is not
required, and a more appropriate tag is either Acked-by or
Reviewed-by. I'll add Acked-by for you and respin, thanks!

[0] https://docs.google.com/presentation/d/1J4VTSTuiJ88xcvOrYg7HRvwUoxOW9qvnBqOfoPPuc64/edit

  Luis
