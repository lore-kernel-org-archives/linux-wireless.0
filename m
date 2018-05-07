Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:39761 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbeEGHrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 03:47:53 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <0f8aaff5ecad8af6d146453d4d3a5d4dd145977b.camel@intel.com>
References: <CA+icZUXrHmOJPKT0gnym9yOs6Erm3wDOZU3sbr_MGB8pYjfuzA@mail.gmail.com>
 <0f8aaff5ecad8af6d146453d4d3a5d4dd145977b.camel@intel.com>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Mon, 7 May 2018 09:47:51 +0200
Message-ID: <CA+icZUXy5VyJq_L=ipyutvYk6gpsCb9jxHzBa7T3MRhs3XgQKA@mail.gmail.com> (sfid-20180507_094809_819108_E7ABD9F5)
Subject: Re: [linux-firmware] Version in WHENCE file
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000000b9496056b98e353"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0000000000000b9496056b98e353
Content-Type: text/plain; charset="UTF-8"

On Sun, May 6, 2018 at 3:07 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
> On Sun, 2018-05-06 at 14:46 +0200, Sedat Dilek wrote:
>> Hi Luca,
>>
>> I hope I catched the correct MLs (not sure if linux-firmware has a
>> ML,
>> I did not found any in the MAINTAINERS file).
>>
>> I have seen that in the WHENCE file there is "Version" with and
>> without ":", mostly iwlwifi ucodes.
>>
>> As an example:
>>
>>  File: iwlwifi-8265-36.ucode
>> -Version 36.e91976c0.0
>> +Version: 36.e91976c0.0
>>
>> I don't know the workflow: Do you want to fix it in your tree or
>> directly in linux-firmware.git upstream?
>> My attached patch is against upstream.
>
> Thanks, Sedat!
>
> I'm going to send a new pull-request this week, so I can include your
> patch in my tree and as part of the pull-request.
>
> --
> Cheers,
> Luca.

OK, Thanks.
Attached Patch v2 is against your tree [1].
It differs from v1 against upstream.

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/

--0000000000000b9496056b98e353
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-WHENCE-Fix-typo-Version-v2.patch"
Content-Disposition: attachment;
	filename="0001-WHENCE-Fix-typo-Version-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jgvy08sq0

RnJvbSA2ZTNhNTk3NjMyYWIzODYxOTM4M2QyN2EyM2I3MzY5MTIxZGE2ZDFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAY3JlZGF0aXYuZGU+
CkRhdGU6IE1vbiwgNyBNYXkgMjAxOCAwOTo0NDoyNiArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIFdI
RU5DRTogRml4IHR5cG8gVmVyc2lvbiB2MgoKLS0tCiBXSEVOQ0UgfCA1NiArKysrKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDI4IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL1dIRU5D
RSBiL1dIRU5DRQppbmRleCBmZTYzNDM5YjhjYWQuLjM2NzhiYzQxYTBmMCAxMDA2NDQKLS0tIGEv
V0hFTkNFCisrKyBiL1dIRU5DRQpAQCAtODY2LDEwICs4NjYsMTAgQEAgRmlsZTogaXdsd2lmaS03
MjYwLTEzLnVjb2RlCiBWZXJzaW9uOiAyNS4zMC4xMy4wCiAKIEZpbGU6IGl3bHdpZmktNzI2MC0x
Ni51Y29kZQotVmVyc2lvbiAxNi4yNDI0MTQuMAorVmVyc2lvbjogMTYuMjQyNDE0LjAKIAogRmls
ZTogaXdsd2lmaS03MjYwLTE3LnVjb2RlCi1WZXJzaW9uIDE3LmJmYjU4NTM4LjAKK1ZlcnNpb246
IDE3LmJmYjU4NTM4LjAKIAogRmlsZTogaXdsd2lmaS0zMTYwLTcudWNvZGUKIFZlcnNpb246IDIy
LjEuNy4wCkBAIC04OTAsMTAgKzg5MCwxMCBAQCBGaWxlOiBpd2x3aWZpLTMxNjAtMTMudWNvZGUK
IFZlcnNpb246IDI1LjMwLjEzLjAKIAogRmlsZTogaXdsd2lmaS0zMTYwLTE2LnVjb2RlCi1WZXJz
aW9uIDE2LjI0MjQxNC4wCitWZXJzaW9uOiAxNi4yNDI0MTQuMAogCiBGaWxlOiBpd2x3aWZpLTMx
NjAtMTcudWNvZGUKLVZlcnNpb24gMTcuYmZiNTg1MzguMAorVmVyc2lvbjogMTcuYmZiNTg1Mzgu
MAogCiBGaWxlOiBpd2x3aWZpLTcyNjUtOC51Y29kZQogVmVyc2lvbjogMjIuMjQuOC4wCkBAIC05
MTEsMTAgKzkxMSwxMCBAQCBGaWxlOiBpd2x3aWZpLTcyNjUtMTMudWNvZGUKIFZlcnNpb246IDI1
LjMwLjEzLjAKIAogRmlsZTogaXdsd2lmaS03MjY1LTE2LnVjb2RlCi1WZXJzaW9uIDE2LjI0MjQx
NC4wCitWZXJzaW9uOiAxNi4yNDI0MTQuMAogCiBGaWxlOiBpd2x3aWZpLTcyNjUtMTcudWNvZGUK
LVZlcnNpb24gMTcuYmZiNTg1MzguMAorVmVyc2lvbjogMTcuYmZiNTg1MzguMAogCiBGaWxlOiBp
d2x3aWZpLTcyNjVELTEwLnVjb2RlCiBWZXJzaW9uOiAyMy4xNS4xMC4wCkBAIC05MjYsNzMgKzky
Niw3MyBAQCBGaWxlOiBpd2x3aWZpLTcyNjVELTEzLnVjb2RlCiBWZXJzaW9uOiAyNS4zMC4xMy4w
CiAKIEZpbGU6IGl3bHdpZmktNzI2NUQtMTYudWNvZGUKLVZlcnNpb24gMTYuMjQyNDE0LjAKK1Zl
cnNpb246IDE2LjI0MjQxNC4wCiAKIEZpbGU6IGl3bHdpZmktNzI2NUQtMTcudWNvZGUKLVZlcnNp
b24gMTcuMzUyNzM4LjAKK1ZlcnNpb246IDE3LjM1MjczOC4wCiAKIEZpbGU6IGl3bHdpZmktNzI2
NUQtMjEudWNvZGUKLVZlcnNpb24gMjEuMzAyODAwLjAKK1ZlcnNpb246IDIxLjMwMjgwMC4wCiAK
IEZpbGU6IGl3bHdpZmktNzI2NUQtMjIudWNvZGUKLVZlcnNpb24gMjIuMzkxNzQwLjAKK1ZlcnNp
b246IDIyLjM5MTc0MC4wCiAKIEZpbGU6IGl3bHdpZmktNzI2NUQtMjcudWNvZGUKLVZlcnNpb24g
MjcuNTQxMDMzLjAKK1ZlcnNpb246IDI3LjU0MTAzMy4wCiAKIEZpbGU6IGl3bHdpZmktNzI2NUQt
MjkudWNvZGUKLVZlcnNpb24gMjkuM2UzYjRkZTUuMAorVmVyc2lvbjogMjkuM2UzYjRkZTUuMAog
CiBGaWxlOiBpd2x3aWZpLTMxNjgtMjEudWNvZGUKLVZlcnNpb24gMjEuMzAyODAwLjAKK1ZlcnNp
b246IDIxLjMwMjgwMC4wCiAKIEZpbGU6IGl3bHdpZmktMzE2OC0yMi51Y29kZQotVmVyc2lvbiAy
Mi4zOTE3NDAuMAorVmVyc2lvbjogMjIuMzkxNzQwLjAKIAogRmlsZTogaXdsd2lmaS0zMTY4LTI3
LnVjb2RlCi1WZXJzaW9uIDI3LjU0MTAzMy4wCitWZXJzaW9uOiAyNy41NDEwMzMuMAogCiBGaWxl
OiBpd2x3aWZpLTMxNjgtMjkudWNvZGUKLVZlcnNpb24gMjkuM2UzYjRkZTUuMAorVmVyc2lvbjog
MjkuM2UzYjRkZTUuMAogCiBGaWxlOiBpd2x3aWZpLTgwMDBDLTEzLnVjb2RlCiBWZXJzaW9uOiAy
NS4zMC4xMy4wCiAKIEZpbGU6IGl3bHdpZmktODAwMEMtMTYudWNvZGUKLVZlcnNpb24gMTYuMjQy
NDE0LjAKK1ZlcnNpb246IDE2LjI0MjQxNC4wCiAKIEZpbGU6IGl3bHdpZmktODAwMEMtMjEudWNv
ZGUKLVZlcnNpb24gMjEuMzAyODAwLjAKK1ZlcnNpb246IDIxLjMwMjgwMC4wCiAKIEZpbGU6IGl3
bHdpZmktODAwMEMtMjIudWNvZGUKLVZlcnNpb24gMjIuMzkxNzQwLjAKK1ZlcnNpb246IDIyLjM5
MTc0MC4wCiAKIEZpbGU6IGl3bHdpZmktODAwMEMtMjcudWNvZGUKLVZlcnNpb24gMjcuNTQxMDMz
LjAKK1ZlcnNpb246IDI3LjU0MTAzMy4wCiAKIEZpbGU6IGl3bHdpZmktODAwMEMtMzEudWNvZGUK
LVZlcnNpb24gMzEuNTYwNDg0LjAKK1ZlcnNpb246IDMxLjU2MDQ4NC4wCiAKIEZpbGU6IGl3bHdp
ZmktODAwMEMtMzQudWNvZGUKLVZlcnNpb24gMzQuNjEwMjg4LjAKK1ZlcnNpb246IDM0LjYxMDI4
OC4wCiAKIEZpbGU6IGl3bHdpZmktODAwMEMtMzYudWNvZGUKLVZlcnNpb24gMzYuNzU5NmFmZDQu
MAorVmVyc2lvbjogMzYuNzU5NmFmZDQuMAogCiBGaWxlOiBpd2x3aWZpLTgyNjUtMjEudWNvZGUK
LVZlcnNpb24gMjEuMzAyODAwLjAKK1ZlcnNpb246IDIxLjMwMjgwMC4wCiAKIEZpbGU6IGl3bHdp
ZmktODI2NS0yMi51Y29kZQotVmVyc2lvbiAyMi4zOTE3NDAuMAorVmVyc2lvbjogMjIuMzkxNzQw
LjAKIAogRmlsZTogaXdsd2lmaS04MjY1LTI3LnVjb2RlCi1WZXJzaW9uIDI3LjU0MTAzMy4wCitW
ZXJzaW9uOiAyNy41NDEwMzMuMAogCiBGaWxlOiBpd2x3aWZpLTgyNjUtMzEudWNvZGUKLVZlcnNp
b24gMzEuNTYwNDg0LjAKK1ZlcnNpb246IDMxLjU2MDQ4NC4wCiAKIEZpbGU6IGl3bHdpZmktODI2
NS0zNC51Y29kZQotVmVyc2lvbiAzNC42MTAyODguMAorVmVyc2lvbjogMzQuNjEwMjg4LjAKIAog
RmlsZTogaXdsd2lmaS04MjY1LTM2LnVjb2RlCiBWZXJzaW9uOiAzNi43NTk2YWZkNC4wCi0tIAoy
LjE3LjAKCg==
--0000000000000b9496056b98e353--
