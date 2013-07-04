Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:43982 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737Ab3GDAWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 20:22:47 -0400
Received: by mail-la0-f43.google.com with SMTP id gw10so698731lab.16
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 17:22:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130702172537.DC8F62006D3@clearcreek.mtv.corp.google.com>
References: <20130702172537.DC8F62006D3@clearcreek.mtv.corp.google.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 3 Jul 2013 17:22:25 -0700
Message-ID: <CAB=NE6UdCnNzd-_VjdePSgwKUhrJ4XWycT_4Wg0JoUkDncDpAg@mail.gmail.com> (sfid-20130704_022253_996121_BBAF10B9)
Subject: Re: wireless-regdb: 5GHz rule for Indonesia regdomain
To: Paul Stewart <pstew@chromium.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 2, 2013 at 10:20 AM, Paul Stewart <pstew@chromium.org> wrote:
> Pursuant to
> http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf, provide a 5GHz rule for Indonesian regulatory domain.

This looks good to me and matches QCA's work on this, but we also can
enable VHT80. Given that I am working on sending a huge series of
VHT80 patches I'll roll this into my series and modify your patch to
add VHT80 as well. Will send out shortly.

  Luis
