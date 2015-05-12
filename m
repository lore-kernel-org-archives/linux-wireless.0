Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbbELLH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 07:07:57 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Gujulan Elango\, Hari Prasath \(H.\)" <hgujulan@visteon.com>
Cc: "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"joe\@perches.com" <joe@perches.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Babu\, Viswanathan \(V.\)" <vbabu3@visteon.com>
Subject: Re: [PATCH] staging: rtl8723au: remove redundant initialization
References: <20150512095535.GA5332@IND12F0122>
Date: Tue, 12 May 2015 07:07:54 -0400
In-Reply-To: <20150512095535.GA5332@IND12F0122> (Gujulan Elango's message of
	"Tue, 12 May 2015 10:01:18 +0000")
Message-ID: <wrfjtwvi3vg5.fsf@redhat.com> (sfid-20150512_130802_250654_C9D252A6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com> writes:
> The variable pHalData is initialized twice in this same function with
> same value.So removing one of them.
>
> Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks fine to me

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
