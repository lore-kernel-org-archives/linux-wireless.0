Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38393 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0HAX43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 19:56:29 -0400
Received: by iwn7 with SMTP id 7so3516875iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 16:56:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A350122DF3C44@orsmsx506.amr.corp.intel.com>
References: <AANLkTimrv507n5-WmikUOhPE95wM1p1_Qtd65rOA1hei@mail.gmail.com>
	<E9954878DD1FB34FAE5187FB88C58A350122DF3C44@orsmsx506.amr.corp.intel.com>
Date: Sun, 1 Aug 2010 19:56:28 -0400
Message-ID: <AANLkTi=urmiEPXN+Bpk-6_KwcqSgFuqKc1LK0njNd5E_@mail.gmail.com>
Subject: Re: Intel Wireless: Microcode SW error detected.
From: Malthe Borch <mborch@gmail.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Sternberg, Jay E" <jay.e.sternberg@intel.com>
Content-Type: multipart/mixed; boundary=0050450168c81e8358048ccbd5de
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0050450168c81e8358048ccbd5de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Attached is the additional logging output I get when I load the drivers usi=
ng:

  modprobe iwlagn debug=3D0x43fff

\malthe

On 27 July 2010 10:40, Guy, Wey-Yi W <wey-yi.w.guy@intel.com> wrote:
> Add Jay to the thread,
>
> Jay, could you help to take a look at it. Thanks
>
> Wey-Yi Guy
> Intel Corporation
> 2111 N.E. 25th Avenue =C2=A0M/S JF3-308
> Hillsboro OR 97124-5961
> USA
> Work Phone: 503-264-6023 (OR)
> Cell Phone: 503-329-8410
> Email: wey-yi.w.guy@intel.com
>
>
> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@v=
ger.kernel.org] On Behalf Of Malthe Borch
> Sent: Monday, July 26, 2010 2:19 PM
> To: linux-wireless@vger.kernel.org
> Subject: Intel Wireless: Microcode SW error detected.
>
> I get this with the latest and greatest Intel firmware 9.221.4.1 build 25=
532.
>
> Ultimately enabling the device fails with: "uCode did not respond OK."
>

--0050450168c81e8358048ccbd5de
Content-Type: application/octet-stream; name=dmesg
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gccjuasy0

aWVlZTgwMjExIHBoeTA6IEkgaXdsX3ByaW50X3J4X2NvbmZpZ19jbWQgUlggQ09ORklHOgppd2wg
ZGF0YTogMDAwMDAwMDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwICAuLi4uLi4uLi4uLi4uLi4uCml3bCBkYXRhOiAwMDAwMDAxMDogMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMGUgMjQgMDAgMDAgMDAgMDAgIC4uLi4uLi4uLi4uJC4uLi4KaXds
IGRhdGE6IDAwMDAwMDIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAgLi4uLi4uLi4uLi4uLi4uLgppd2wgZGF0YTogMDAwMDAwMzA6IDAwIDAwICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAuLgppZWVlODAyMTEgcGh5MDog
SSBpd2xfcHJpbnRfcnhfY29uZmlnX2NtZCB1MTYgY2hhbm5lbDogMHgwCmllZWU4MDIxMSBwaHkw
OiBJIGl3bF9wcmludF9yeF9jb25maWdfY21kIHUzMiBmbGFnczogMHgwMDAwMDAwMAppZWVlODAy
MTEgcGh5MDogSSBpd2xfcHJpbnRfcnhfY29uZmlnX2NtZCB1MzIgZmlsdGVyX2ZsYWdzOiAweDAw
MDAwMDAwCmllZWU4MDIxMSBwaHkwOiBJIGl3bF9wcmludF9yeF9jb25maWdfY21kIHU4IGRldl90
eXBlOiAweDAKaWVlZTgwMjExIHBoeTA6IEkgaXdsX3ByaW50X3J4X2NvbmZpZ19jbWQgdTggb2Zk
bV9iYXNpY19yYXRlczogMHgwMAppZWVlODAyMTEgcGh5MDogSSBpd2xfcHJpbnRfcnhfY29uZmln
X2NtZCB1OCBjY2tfYmFzaWNfcmF0ZXM6IDB4MDAKaWVlZTgwMjExIHBoeTA6IEkgaXdsX3ByaW50
X3J4X2NvbmZpZ19jbWQgdThbNl0gbm9kZV9hZGRyOiAwMDowMDowMDowMDowMDowMAppZWVlODAy
MTEgcGh5MDogSSBpd2xfcHJpbnRfcnhfY29uZmlnX2NtZCB1OFs2XSBic3NpZF9hZGRyOiAwMDow
MDowMDowMDowMDowMAppZWVlODAyMTEgcGh5MDogSSBpd2xfcHJpbnRfcnhfY29uZmlnX2NtZCB1
MTYgYXNzb2NfaWQ6IDB4MAppZWVlODAyMTEgcGh5MDogSSBpd2xfaXJxX2hhbmRsZV9lcnJvciBS
ZXN0YXJ0aW5nIGFkYXB0ZXIgZHVlIHRvIHVDb2RlIGVycm9yLgppZWVlODAyMTEgcGh5MDogSSBp
d2xfcnhfcmVwbHlfYWxpdmUgQWxpdmUgdWNvZGUgc3RhdHVzIDB4MDAwMDAwMDAgcmV2aXNpb24g
MHgxIDB4MAppZWVlODAyMTEgcGh5MDogSSBpd2xfcnhfcmVwbHlfYWxpdmUgUnVudGltZSBBbGl2
ZSByZWNlaXZlZC4KaXdsYWduIDAwMDA6MDI6MDAuMDogdUNvZGUgZGlkIG5vdCByZXNwb25kIE9L
LgppZWVlODAyMTEgcGh5MDogVSBfX2l3bF9kb3duIGl3bGFnbiBpcyBnb2luZyBkb3duCmllZWU4
MDIxMSBwaHkwOiBVIGl3bF9jbGVhcl91Y29kZV9zdGF0aW9ucyBDbGVhcmluZyB1Y29kZSBzdGF0
aW9ucyBpbiBkcml2ZXIKaWVlZTgwMjExIHBoeTA6IFUgaXdsX2NsZWFyX3Vjb2RlX3N0YXRpb25z
IE5vIGFjdGl2ZSBzdGF0aW9ucyBmb3VuZCB0byBiZSBjbGVhcmVkCmllZWU4MDIxMSBwaHkwOiBV
IGl3bF9hcG1fc3RvcCBTdG9wIGNhcmQsIHB1dCBpbiBsb3cgcG93ZXIgc3RhdGUKaWVlZTgwMjEx
IHBoeTA6IFUgaXdsX2FwbV9zdG9wX21hc3RlciBzdG9wIG1hc3RlcgppZWVlODAyMTEgcGh5MDog
VSBpd2xfY2xlYXJfZnJlZV9mcmFtZXMgMCBmcmFtZXMgb24gcHJlLWFsbG9jYXRlZCBoZWFwIG9u
IGNsZWFyLgppd2xhZ24gMDAwMDowMjowMC4wOiBTVEFSVF9BTElWRSB0aW1lb3V0IGFmdGVyIDQw
MDBtcy4KaWVlZTgwMjExIHBoeTA6IFUgaXdsX2NvbmZpZ3VyZV9maWx0ZXIgRW50ZXI6IGNoYW5n
ZWQ6IDB4MCwgdG90YWw6IDB4ODAwMDAwMDAK
--0050450168c81e8358048ccbd5de--
