Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:47277 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbcCAPgi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 10:36:38 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] staging: rtl8723au: use list_first_entry*
Date: Tue,  1 Mar 2016 23:35:30 +0800
Message-Id: <cover.1456845896.git.geliangtang@163.com> (sfid-20160301_163749_936910_22370F1C)
In-Reply-To: <wrfjio1gp2uk.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2016 at 09:39:15PM -0500, Jes Sorensen wrote:
> Geliang Tang <geliangtang@163.com> writes:
> > Use list_first_entry*() instead of container_of() to simplify the code.
> >
> > Signed-off-by: Geliang Tang <geliangtang@163.com>
> > ---
> >  drivers/staging/rtl8723au/core/rtw_recv.c | 49 +++++++++----------------------
> >  drivers/staging/rtl8723au/core/rtw_xmit.c | 26 +++++-----------
> >  2 files changed, 22 insertions(+), 53 deletions(-)
> 
> This looks fine to me. When these changes gets large, it may be better
> to break them down into multiple patches as it's easier to debug if
> there is a bug somewhere.
>

Changes in v2:
 - split it into three patches.

Geliang Tang (3):
  staging: rtl8723au: core: rtw_recv: use list_first_entry_or_null()
  staging: rtl8723au: core: rtw_xmit: use list_first_entry_or_null()
  staging: rtl8723au: core: rtw_recv: use list_first_entry()

 drivers/staging/rtl8723au/core/rtw_recv.c | 47 +++++++++----------------------
 drivers/staging/rtl8723au/core/rtw_xmit.c | 26 ++++++-----------
 2 files changed, 21 insertions(+), 52 deletions(-)

-- 
2.5.0


